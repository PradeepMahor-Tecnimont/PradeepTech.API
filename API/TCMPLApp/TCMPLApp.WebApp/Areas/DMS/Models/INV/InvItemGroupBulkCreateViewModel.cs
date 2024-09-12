using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemGroupBulkCreateViewModel
    {
        [Display(Name = "Item group description")]
        [Required]
        public string ItemGroupDesc { get; set; }

        public IFormFile file { get; set; }
    }
}