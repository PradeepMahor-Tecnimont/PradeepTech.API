using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvTransactionDataTableListExcel
    {
        [Display(Name = "Date")]        
        public string TransDate { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Name")]
        public string ParentName { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Name")]
        public string AssignName { get; set; }

        [Display(Name = "Type")]
        public string TransTypeDesc { get; set; }

        [Display(Name = "Item type")]
        public string ItemTypeDesc { get; set; }

        [Display(Name = "Item")]
        public string ItemId { get; set; }

        [Display(Name = "Item details")]
        public string ItemDetails { get; set; }

        [Display(Name = "Usable")]
        public string ItemUsable { get; set; }
    }
}