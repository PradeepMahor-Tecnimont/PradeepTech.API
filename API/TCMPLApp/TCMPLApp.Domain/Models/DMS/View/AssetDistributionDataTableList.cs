using System;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using static System.Net.Mime.MediaTypeNames;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetDistributionDataTableList
    {
        private string _empstatusDeskisblocked { get; set; }
        private string _scrap { get; set; }

        [Display(Name = "Barcode")]
        public string Barcode { get; set; }

        [Display(Name = "Ponum")]
        public string Ponum { get; set; }

        [Display(Name = "Podate")]
        public DateTime? Podate { get; set; }

        [Display(Name = "Grnum")]
        public string Grnum { get; set; }

        [Display(Name = "Sap.Assetcode")]
        public string SapAssetcode { get; set; }

        [Display(Name = "Serial number")]
        public string Serialnum { get; set; }

        [Display(Name = "Make")]
        public string Make { get; set; }

        [Display(Name = "Model")]
        public string Model { get; set; }

        [Display(Name = "Company name")]
        public string Compname { get; set; }

        [Display(Name = "Scrap")]
        public string Scrap
        {
            get { return _scrap == "1" ? "Yes" : "No"; }
            set { _scrap = value; }
        }

        [Display(Name = "Sub asset type")]
        public string SubAssetType { get; set; }

        [Display(Name = "LotDesc")]
        public string LotDesc { get; set; }

        [Display(Name = "Assignment type ")]
        public string AsgmtType { get; set; }

        [Display(Name = "Assigned to")]
        public string AssignedTo { get; set; }

        [Display(Name = "Name Office")]
        public string NameOffice { get; set; }

        [Display(Name = "Parent/Floor")]
        public string ParentFloor { get; set; }

        [Display(Name = "Assign/Wing")]
        public string AssignWing { get; set; }

        [Display(Name = "Grade/Cabin")]
        public string GradeCabin { get; set; }

        [Display(Name = "Employee type/WorkArea")]
        public string EmptypeWorkarea { get; set; }

        [Display(Name = "EmpstatusDeskisblocked")]
        public string EmpstatusDeskisblocked
        {
            get { return _empstatusDeskisblocked == "1" ? "Yes" : "No"; }
            set { _empstatusDeskisblocked = value; }
        }
    }
}