using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class UserIdentityProfile : Common.DBProcMessageOutput
    {
        public string PTcmMetaId { get; set; }
        public string PTcmPersonId{ get; set; }

        public string PEmpno { get; set; }

        public string PEmployeeName { get; set; }

        public string PCostcode { get; set; }

        public IEnumerable<ProfileAction> PProfileActions { get; set; }

        public string PModulesCsv { get; set; }
    }
}
