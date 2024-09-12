using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGProjectMasterDetail : DBProcMessageOutput
    {        
        public string PName { get; set; }
        public string PMngrname { get; set; }
        public string PMngremail { get; set; }
        public decimal PIsclosed{ get; set; }      
        public string PModifiedby { get; set; }
        public DateTime? PModifiedon { get; set; }
    }
}