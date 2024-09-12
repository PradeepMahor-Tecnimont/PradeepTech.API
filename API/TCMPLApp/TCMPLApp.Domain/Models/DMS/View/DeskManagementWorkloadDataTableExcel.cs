using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskManagementWorkloadDataTableExcel
    {        
        [Display(Name = "Deskid")] 
        public string Deskid { get; set; }
        [Display(Name = "Office")] 
        public string Office { get; set; }
        [Display(Name = "Floor")] 
        public string Floor { get; set; }
        [Display(Name = "Wing")] 
        public string Wing { get; set; }
        [Display(Name = "Cabin")] 
        public string Cabin { get; set; }
        [Display(Name = "Empno1")] 
        public string Empno1 { get; set; }
        [Display(Name = "Name1")] 
        public string Name1 { get; set; }
        [Display(Name = "Userid1")] 
        public string Userid1 { get; set; }
        [Display(Name = "Dept1")] 
        public string Dept1 { get; set; }
        [Display(Name = "Grade1")] 
        public string Grade1 { get; set; }
        [Display(Name = "Desg1")] 
        public string Desg1 { get; set; }
        [Display(Name = "Shift1")] 
        public string Shift1 { get; set; }
        [Display(Name = "Email1")] 
        public string Email1 { get; set; }
        [Display(Name = "Empno2")] 
        public string Empno2 { get; set; }
        [Display(Name = "Name2")] 
        public string Name2 { get; set; }
        [Display(Name = "Userid2")] 
        public string Userid2 { get; set; }
        [Display(Name = "Dept2")] 
        public string Dept2 { get; set; }
        [Display(Name = "Grade2")] 
        public string Grade2 { get; set; }
        [Display(Name = "Desg2")] 
        public string Desg2 { get; set; }
        [Display(Name = "Shift2")] 
        public string Shift2 { get; set; }
        [Display(Name = "Email2")] 
        public string Email2 { get; set; }
        [Display(Name = "Compname")] 
        public string Compname { get; set; }
        [Display(Name = "Computer")] 
        public string Computer { get; set; }
        [Display(Name = "PC Model")] 
        public string Pcmodel { get; set; }
        [Display(Name = "Monitor1")] 
        public string Monitor1 { get; set; }
        [Display(Name = "Monitor1 Model")] 
        public string Monmodel1 { get; set; }
        [Display(Name = "Monitor2")] 
        public string Monitor2 { get; set; }
        [Display(Name = "Monitor2 Model")] 
        public string Monmodel2 { get; set; }
        [Display(Name = "Telephone")] 
        public string Telephone { get; set; }
        [Display(Name = "Tel Model")] 
        public string Telmodel { get; set; }
        [Display(Name = "Printer")] 
        public string Printer { get; set; }
        [Display(Name = "Printer Model")] 
        public string Printmodel { get; set; }
        [Display(Name = "Doc. Stn")] 
        public string Docstn { get; set; }
        [Display(Name = "Doc. Stn. Model")] 
        public string Docstnmodel { get; set; }
        [Display(Name = "PC RAM")] 
        public decimal? PcRam { get; set; }
        [Display(Name = "Grph. Card")] 
        public string PcGcard { get; set; }

    }
}