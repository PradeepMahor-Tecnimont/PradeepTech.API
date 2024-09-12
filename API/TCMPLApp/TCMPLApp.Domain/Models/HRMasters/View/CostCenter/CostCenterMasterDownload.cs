using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CostCenterMasterDownload
    {
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Abbreviation")]
        public string Abbr { get; set; }

        [Display(Name = "Hod")]
        public string Hod { get; set; }

        [Display(Name = "Hod name")]
        public string Hod_name { get; set; }

        [Display(Name = "Hod person id")]
        public string Hod_personid { get; set; }

        [Display(Name = "Engg / Non engg")]
        public string EnggNonenggDesc { get; set; }

        [Display(Name = "No of emps")]
        public string No_of_emps { get; set; }

        [Display(Name = "Cost group")]
        public string Cost_group { get; set; }

        [Display(Name = "Group")]
        public string Groups { get; set; }

        [Display(Name = "Cost type")]
        public string Cost_type { get; set; }

        [Display(Name = "Secretary")]
        public string Secretary { get; set; }

        [Display(Name = "Secretary name")]
        public string Secretary_name { get; set; }

        [Display(Name = "Secretary person id")]
        public string Secretary_personid { get; set; }

        [Display(Name = "Start date")]
        public string Sdate { get; set; }

        [Display(Name = "End date")]
        public string Edate { get; set; }

        [Display(Name = "SAP cost code")]
        public string Sapcc { get; set; }

        [Display(Name = "Parent cost code")]
        public string Parent_costcode { get; set; }

        [Display(Name = "Active")]
        public string Active { get; set; }

        [Display(Name = "Count FTC")]
        public string Count_ftc { get; set; }

        [Display(Name = "Count Roll")]
        public string Count_roll { get; set; }

        [Display(Name = "Dy Hod")]
        public string Dy_hod { get; set; }

        [Display(Name = "Dy Hod name")]
        public string Dy_hod_name { get; set; }

        [Display(Name = "Dy Hod person id")]
        public string Dy_hod_personid { get; set; }

        [Display(Name = "Changed no. emps")]
        public string Changed_no_emps { get; set; }

        [Display(Name = "TCM cost code")]
        public string Tcm_costcode { get; set; }

        [Display(Name = "TCM act phase")]
        public string Tcm_act_phase { get; set; }

        [Display(Name = "TCM pas phase")]
        public string Tcm_pas_phase { get; set; }

        [Display(Name = "PO")]
        public string Po { get; set; }

        [Display(Name = "TM01 group")]
        public string Tm01_group { get; set; }

        [Display(Name = "TMA group")]
        public string Tma_group { get; set; }

        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Display(Name = "Group chart")]
        public string Group_chart { get; set; }

        [Display(Name = "Italian name")]
        public string Italian_name { get; set; }
        
        [Display(Name = "Company report")]
        public string Company_report { get; set; }

        [Display(Name = "Phase")]
        public string Phase { get; set; }

    }
}
