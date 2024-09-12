using DocumentFormat.OpenXml.Vml;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobEditAFCViewModel
    {
        [Display(Name = "Project no.")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "Client")]
        public string Client { get; set; }

        [Required]
        [Display(Name = "Project type")]
        public string ProjectType { get; set; }

        [Required]
        [Display(Name = "Invoicing to group company")]
        public string InvoiceToGrpCompany { get; set; }        
    }
}
