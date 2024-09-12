using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class HrMisEmployeeDetails : DBProcMessageOutput
    {
        public DateTime? PDoj { get; set; }

        public string PGrade { get; set; }

        public string PDesignation { get; set; }

        public string PDepartment { get; set; }
    }
}