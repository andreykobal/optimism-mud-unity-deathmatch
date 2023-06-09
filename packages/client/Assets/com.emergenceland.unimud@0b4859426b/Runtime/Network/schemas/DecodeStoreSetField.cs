#nullable enable
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using mud.Client;
using mud.Network.IStore;
using UnityEngine;

namespace mud.Network.schemas
{
    using Property = Dictionary<string, object>;

    public static partial class DecodeStore
    {
        public static async Task<(TableSchema, Property?, Property?)> DecodeStoreSetField(
            IStoreService store, TableId table,
            int schemaIndex, string data)
        {
            var schema = await Schema.RegisterSchema(store, table, null);
            var value = DataDecoder.DecodeField(schema, schemaIndex, data);

            var staticFields = schema.StaticFields;
            var dynamicFields = schema.DynamicFields;

            var defaultValues = staticFields
                .Select(fieldType => StaticFieldUtils.DecodeStaticField(fieldType, Array.Empty<byte>(), 0))
                .Concat(dynamicFields.Select(
                    fieldType => DataDecoder.DecodeDynamicField(fieldType, Array.Empty<byte>())))
                .ToList();

            var initialValue = defaultValues.Select((v, index) => new { index, value = v })
                .ToDictionary(pair => pair.index, pair => pair.value);

            var metadata = await Metadata.RegisterMetadata(store, table);
            if (metadata != null)
            {
                return (schema, ClientUtils.CreateProperty((metadata.FieldNames[0], value[schemaIndex])),
                    ClientUtils.CreateProperty((metadata.FieldNames[0], initialValue[schemaIndex])));
            }

            Debug.LogWarning(
                $"Received data for {table}, but could not find table metadata for field names. Did your contracts get autogenerated and deployed properly?"
            );

            return (schema, ClientUtils.CreateProperty((schemaIndex.ToString(), value)),
                ClientUtils.CreateProperty((schemaIndex.ToString(), initialValue)));
        }
    }
}
