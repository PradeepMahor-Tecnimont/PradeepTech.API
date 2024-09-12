using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAllocationSWPDataTableList
    {
        private string _emp1IsSwpEligible;
        private string _emp2IsSwpEligible;
        public string Deskid { get; set; }
        public string Office { get; set; }
        public string Floor { get; set; }
        public string Wing { get; set; }
        public string Cabin { get; set; }
        public string Empno1 { get; set; }
        public string Name1 { get; set; }
        public string Userid1 { get; set; }
        public string Dept1 { get; set; }
        public string Grade1 { get; set; }
        public string Desg1 { get; set; }
        public string Shift1 { get; set; }
        public string Email1 { get; set; }
        public string Empno2 { get; set; }
        public string Name2 { get; set; }
        public string Userid2 { get; set; }
        public string Dept2 { get; set; }
        public string Grade2 { get; set; }
        public string Desg2 { get; set; }
        public string Shift2 { get; set; }

        public string Email2 { get; set; }
        public string Compname { get; set; }
        public string Computer { get; set; }
        public string PcModel { get; set; }
        public string Monitor1 { get; set; }
        public string Monitor1Model { get; set; }
        public string Monitor2 { get; set; }
        public string Monitor2Model { get; set; }
        public string Telephone { get; set; }
        public string TelModel { get; set; }
        public string Printer { get; set; }
        public string PrinterModel { get; set; }
        public string DockingStation { get; set; }
        public string DockingStationModel { get; set; }
        public decimal? PcRam { get; set; }
        public string GraphicCard { get; set; }

        public string Emp1IsSwpEligible
        {
            get { return _emp1IsSwpEligible == "OK" ? "Yes" : _emp1IsSwpEligible == "KO" ? "No" : ""; }
            set { _emp1IsSwpEligible = value; }
        }

        public string Emp1Pws { get; set; }

        public string Emp2IsSwpEligible
        {
            get { return _emp2IsSwpEligible == "OK" ? "Yes" : _emp2IsSwpEligible == "KO" ? "No" : ""; }
            set { _emp2IsSwpEligible = value; }
        }

        public string Emp2Pws { get; set; }

        public string Emp1Project { get; set; }
        public string Emp2Project { get; set; }
    }
}
