using DocumentFormat.OpenXml.Wordprocessing;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AdminPWSExcelModel
    {
        //private string _primaryWorkspace;

        private string _isLaptopUser;
        private string _isSwpEligible;

        public string Empno { get; set; }

        public string EmployeeName { get; set; }
        public string Parent { get; set; }

        public string Emptype { get; set; }
        public string EmpGrade { get; set; }

        public string Assign { get; set; }

        public string AssignDeptGroup { get; set; }

        public string WorkArea { get; set; }

        public string OfficeLocationDesc { get; set; }

        public string Email { get; set; }
        public string Deskid { get; set; }


        public string IsLaptopUser
        {
            get { return _isLaptopUser.StartsWith("1") ? "Yes" : "No"; }
            set { _isLaptopUser = value; }

        }

        public string IsSwpEligible
        {
            get { return _isSwpEligible == "OK" ? "Yes" : "No"; }
            set { _isSwpEligible = value; }

        }
        public string IsDualMonitorUserText { get; set; }

        //public string PrimaryWorkspace
        //{
        //    get
        //    {
        //        if (_primaryWorkspace.StartsWith("1"))
        //            return "Office";
        //        else if (_primaryWorkspace.StartsWith("2"))
        //            return "Smart";
        //        else
        //            return "OnDeputation";
        //    }
        //    set { _primaryWorkspace = value; }
        //}
        public string PrimaryWorkSpaceText { get; set; }

    }
}
