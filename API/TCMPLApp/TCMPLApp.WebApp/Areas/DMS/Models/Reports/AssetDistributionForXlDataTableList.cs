using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetDistributionForXlDataTableList
    {
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
        public string Scrap { get; set; }

        [Display(Name = "Sub asset type")]
        [JsonProperty(PropertyName = "Sub asset type")]
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

        [Display(Name = "AssignCode/Wing")]
        public string AssignWing { get; set; }

        [Display(Name = "Grade/Cabin")]
        public string GradeCabin { get; set; }

        [Display(Name = "Employee type/WorkArea")]
        public string EmptypeWorkarea { get; set; }

        [Display(Name = "EmpstatusDeskisblocked")]
        public string EmpstatusDeskisblocked { get; set; }
    }

    public class CustomContractResolverForAssetDistributionXL : DefaultContractResolver
    {
        private Dictionary<string, string> PropertyMappings { get; set; }

        public CustomContractResolverForAssetDistributionXL()
        {
            this.PropertyMappings = new Dictionary<string, string>
            {
                {"Barcode", "BarCode"},
                {"Ponum", "PO Number"},
                {"Podate", "PO Date"},
                {"Grnum", "GR Number"},
                {"SapAssetcode", "Sap Asset Code"},
                {"Serialnum", "Serial Number"},
                {"Model", "Asset Model"},
                {"Compname", "PC / Laptop Name"},
                {"Scrap", "Scrap"},
                {"SubAssetType", "Sub Asset Type"},
                {"LotDesc", "Lot Description"},
                {"AsgmtType", "Assignment Type"},
                {"AssignedTo", "Assigned To"},
                {"NameOffice", "Office"},
                {"ParentFloor", "Parent / Floor"},
                {"AssignWing", "AssignCode / Wing"},
                {"GradeCabin", "Grade / Cabin"},
                {"EmptypeWorkarea", "Employee type / WorkArea"},
                {"EmpstatusDeskisblocked", "Employee status / Desk is blocked"}
            };
        }

        protected override string ResolvePropertyName(string propertyName)
        {
            string resolvedName = null;
            var resolved = this.PropertyMappings.TryGetValue(propertyName, out resolvedName);
            return (resolved) ? resolvedName : base.ResolvePropertyName(propertyName);
        }
    }
}