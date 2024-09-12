using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters.View
{
    public class CostCenterMasterMain
    {
        public string CostCodeId { get; set; }

        [Display(Name = "Cost code")]
        public string CostCode { get; set; }

        [Display(Name = "Cost code name")]
        public string Name { get; set; }

        [Display(Name = "Abbreviation")]
        public string Abbr { get; set; }

        [Display(Name = "HoD")]
        public string HoD { get; set; }

        public string HoDPersonId { get; set; }

        [Display(Name = "HoD")]
        public string HoDName { get; set; }        

        [Display(Name = "Abbreviation")]
        public string HoDAbbr { get; set; }

        [Display(Name = "Employees")]
        public Int32 NoOfEmps { get; set; }

        public string CostGroupId { get; set; }

        [Display(Name = "Cost group")]
        public string CostGroup { get; set; }

        [Display(Name = "Cost group")]
        public string CostGroupName { get; set; }

        [Display(Name = "Group")]
        public string GroupId { get; set; }

        [Display(Name = "Group")]
        public string Groups { get; set; }

        [Display(Name = "Group")]
        public string GroupsName { get; set; }

        public string CostTypeId { get; set; }

        [Display(Name = "Cost type")]
        public string CostType { get; set; }

        [Display(Name = "Cost type")]
        public string CostTypeName { get; set; }

        [Display(Name = "Secretary")]
        public string Secretary { get; set; }

        public string SecretaryPersonId { get; set; }

        [Display(Name = "Secretary")]
        public string SecretaryName { get; set; }                

        [Display(Name = "Start date")]

        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? SDate { get; set; }

        [Display(Name = "End date")]

        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? EDate { get; set; }

        [Display(Name = "SAP cost code")]
        public string SAPCC { get; set; }

        [Display(Name = "Parent cost code")]
        public string ParentCostCode { get; set; }

        public string ParentCostCodeId { get; set; }

        [Display(Name = "Parent cost code")]
        public string ParentCostCodeName { get; set; }

        [Display(Name = "Active")]
        public Int32 Active { get; set; }

        [Display(Name = "Employees - FTC")]
        public Int32 CntFTC { get; set; }

        [Display(Name = "Employees - Roll")]
        public Int32 CntRoll { get; set; }

        public Int32 IsLinked { get; set; }

        public string IsEditable { get; set; }

        [Display(Name = "Engg / Non engg")]
        public string EnggNonengg { get; set; }

        [Display(Name = "Engg / Non engg")]
        public string EnggNonenggDesc { get; set; }
    }
}
