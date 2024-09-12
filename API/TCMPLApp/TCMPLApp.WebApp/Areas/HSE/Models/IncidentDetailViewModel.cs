using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{ 
    public class IncidentDetailViewModel
    {
        
        [Display(Name = "Id")]
        public string Reportid { get; set; }

        [Display(Name = "Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Reportdate { get; set; }

        [Display(Name = "Year")]
        public string Yyyy { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Location")]
        public string Loc { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Incident date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Incdate { get; set; }

        [Display(Name = "Incident time")]
        [DisplayFormat(DataFormatString = "{0:00.00}")]
        public string Inctime { get; set; }
                
        public string Inctype { get; set; }

        [Display(Name = "Incident type")]
        public string Inctypename { get; set; }
                
        public string Nature { get; set; }

        [Display(Name = "Nature of injury")]
        public string Naturename { get; set; }
        
        [Display(Name = "Body part injured")]
        public string Injuredparts { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Name of injuried person")]
        public string Empname { get; set; }

        [Display(Name = "Designation")]
        public string Desg { get; set; }

        [Display(Name = "Age")]
        public string Age { get; set; }

        [Display(Name = "Gender")]
        public string Sex { get; set; }

        [Display(Name = "Subcontract")]
        public string Subcontract { get; set; }

        [Display(Name = "Subcontract name")]
        public string Subcontractname { get; set; }

        [Display(Name = "Referred medical aid")]
        public string Aid { get; set; }

        [Display(Name = "Brief description of accident / incident")]
        public string Description { get; set; }

        [Display(Name = "Probable causes")]
        public string Causes { get; set; }

        [Display(Name = "Immediate action")]
        public string Action { get; set; }

        [Display(Name = "Corrective actions")]
        public string CorrectiveActions { get; set; }

        [Display(Name = "Closer")]
        public string Closer { get; set; }

        [Display(Name = "Closer date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? CloserDate { get; set; }

        [Display(Name = "Attchment link")]
        public string AttchmentLink { get; set; }

        [Display(Name = "Mail to")]
        public decimal Mailsend { get; set; }

        public decimal Isactive { get; set; }

        public decimal Isdelete { get; set; }

    }


}