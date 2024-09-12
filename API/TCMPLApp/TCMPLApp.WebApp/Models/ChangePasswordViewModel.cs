using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class ChangePasswordViewModel
    {
        [Required]
        [Display(Name = "New password")]
        [RegularExpression(@"^.{8,10}$", ErrorMessage = "Password should be between 8 to 10 characters.")]

        public string NewPassword { get; set; }

        [Required]
        [Display(Name = "Confirm password")]
        [Compare(nameof(NewPassword), ErrorMessage = "New password and Confirmation password should match.")]
        public string ConfirmPassword { get; set; }
    
    }
}
