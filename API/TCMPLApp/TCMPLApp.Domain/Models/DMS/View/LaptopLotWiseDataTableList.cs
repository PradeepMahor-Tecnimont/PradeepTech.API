using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class LaptopLotWiseDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "LOT ID")]
        public string LotId { get; set; }

        [Display(Name = "LOT Description")]
        public string LotDesc { get; set; }

        [Display(Name = "AMS Asset ID")]
        public string AmsAssetId { get; set; }

        [Display(Name = "SAP Asset Code")]
        public decimal? SapAssetCode { get; set; }

        [Display(Name = "NB Name")]
        public string NbName { get; set; }
        
        [Display(Name = "NB Serial Number")]
        public string NbSerialnum { get; set; }
        
        [Display(Name = "DS ID")]
        public string DsId { get; set; }

        [Display(Name = "DS Serial Number")]
        public string DsSerialnum { get; set; }

        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Employee Type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }


    }
}
