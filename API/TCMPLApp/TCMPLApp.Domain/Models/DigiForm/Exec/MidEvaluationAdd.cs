using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class MidEvaluationAdd : DBProcMessageOutput
    {
        [Display(Name = "Id")]
        public string PKeyid { get; set; }
        [Display(Name = "Empno")]
        public string PEmpno { get; set; }
        [Display(Name = "Attendance")]
        public string PAttendance { get; set; }
        [Display(Name = "Location")]
        public string PLocation { get; set; }
        [Display(Name = "Skiil 1")]
        public string PSkill1 { get; set; }
        public int? PSkill1Rating { get; set; }
        public string PSkill1Remark { get; set; }
        [Display(Name = "Skiil 2")]
        public string PSkill2 { get; set; }
        public int? PSkill2Rating { get; set; }
        public string PSkill2Remark { get; set; }
        [Display(Name = "Skiil 3")]
        public string PSkill3 { get; set; }
        public int? PSkill3Rating { get; set; }
        public string PSkill3Remark { get; set; }
        [Display(Name = "Skiil 4")]
        public string PSkill4 { get; set; }
        public int? PSkill4Rating { get; set; }
        public string PSkill4Remark { get; set; }
        [Display(Name = "Skiil 5")]
        public string PSkill5 { get; set; }
        public int? PSkill5Rating { get; set; }
        public string PSkill5Remark { get; set; }
        public int? PQue2Rating { get; set; }
        public string PQue2Remark { get; set; }
        public int? PQue3Rating { get; set; }
        public string PQue3Remark { get; set; }
        public int? PQue4Rating { get; set; }
        public string PQue4Remark { get; set; }
        public int? PQue5Rating { get; set; }
        public string PQue5Remark { get; set; }
        public int? PQue6Rating { get; set; }
        public string PQue6Remark { get; set; }
        public string PObservations { get; set; }
    }
}