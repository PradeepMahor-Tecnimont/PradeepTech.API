using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class TPLVaccineBatchImportEmployeesViewModel1
    {

        public string BatchId { get; set; }

        [Required]
        [DataType(DataType.Upload)]
        [MaxFileSizeAttribute(5 * 1024 * 1024)]
        [AllowedExtensions(new string[] { ".xls", ".xlsx" })]
        [Display (Name ="Select file")]
        public IFormFile FileToUpload { get; set; }
    }
}
