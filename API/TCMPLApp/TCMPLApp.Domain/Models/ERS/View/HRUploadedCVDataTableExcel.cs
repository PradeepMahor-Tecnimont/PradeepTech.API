using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.ERS
{
    public class HRUploadedCVDataTableExcel
    {        
        [Display(Name = "Status")]
        public string CvStatus { get; set; }     

        [Display(Name = "Job reference code")]
        public string JobReferenceCode { get; set; }

        [Display(Name = "Job location")]
        public string JobLocation { get; set; }

        [Display(Name = "Date of posting")]
        public string DateOfPosting { get; set; }

        [Display(Name = "Name")]
        public string CandidateName { get; set; }

        [Display(Name = "Email")]
        public string CandidateEmail { get; set; }

        [Display(Name = "Mobile")]
        public string CandidateMobile { get; set; }

        public string CandidateCvDispName { get; set; }

        public string Pan { get; set; }

        [Display(Name = "Referred by")]
        public string ReferedByEmpno { get; set; }

        [Display(Name = "Referred by name")]
        public string Name { get; set; }        
    }

}