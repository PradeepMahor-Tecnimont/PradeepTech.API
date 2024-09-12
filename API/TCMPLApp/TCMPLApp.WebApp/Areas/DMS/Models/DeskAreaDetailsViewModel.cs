using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaDetailsViewModel
    {
        public DeskAreaDetailsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Category Description")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "Area Info")]
        public string AreaInfo { get; set; }

        [Display(Name = "Area Type")]
        public string AreaTypeVal { get; set; }

        [Display(Name = "Area Type")]
        public string AreaTypeText { get; set; }

        [Display(Name = "Is Restricted")]
        public decimal? IsRestrictedVal { get; set; }

        [Display(Name = "Is Restricted")]
        public string IsRestrictedText { get; set; }
    }
}