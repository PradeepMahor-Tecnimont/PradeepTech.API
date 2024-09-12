using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.WebApp.Lib.ToBeDeleted
{
    public class UserIdentityToBeDeleted
    {
        public UserIdentityToBeDeleted()
        {
        }

        [JsonPropertyName("employeeId")]
        public string EmployeeId { get; set; }

        [JsonPropertyName("metaId")]
        public string MetaId { get; set; }

        [JsonPropertyName("userId")]
        public Guid UserId { get; set; }



        [JsonPropertyName("winUID")]
        public string WinUID { get; set; }


        [JsonPropertyName("empNo")]
        public string EmpNo { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("costCode")]
        public string CostCode { get; set; }

        [JsonPropertyName("currentModule")]
        public string CurrentModule { get; set; }

        [JsonPropertyName("moduleProfiles")]
        public IEnumerable<ProfileAction> ProfileActions { get; set; }


        [JsonPropertyName("modules")]
        public IEnumerable<string> Modules { get; set; }


    }

}
