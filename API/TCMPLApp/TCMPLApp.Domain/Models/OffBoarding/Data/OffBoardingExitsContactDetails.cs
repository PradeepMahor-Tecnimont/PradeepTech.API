using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingExitsContactDetails
    {
        public string Empno { get; set; }
        public string EmployeeName { get; set; }
        public string Personid { get; set; }
        public string Grade { get; set; }
        public string Parent { get; set; }
        public string DeptName { get; set; }
        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        [Display(Name = "Date of joining")]

        public string DesgCode { get;set; }
        public string DesgDesc { get; set; }
        public DateTime? Doj { get; set; }
        public DateTime? Dol { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        public DateTime RelievingDate { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        [Display(Name = "Retirement  / Resignation date")]
        public DateTime ResignationDate { get; set; }

        public string MobilePrimary { get; set; }
        public string AlternateNumber { get; set; }
        public string EmailId { get; set; }

    }
}
