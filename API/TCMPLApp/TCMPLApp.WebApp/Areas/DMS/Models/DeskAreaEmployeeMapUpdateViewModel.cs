using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaEmployeeMapUpdateViewModel
    {
        public string KeyId { get; set; }

        [Required]
        [StringLength(3)]
        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Office location")]
        public string OfficeCode { get; set; }

        [Required]
        [StringLength(6)]
        [Display(Name = "Desk")]
        public string DeskId { get; set; }
    }
}