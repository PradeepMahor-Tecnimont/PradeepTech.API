using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LogFileViewModel
    {
        [Display(Name = "File name")]
        public string FileName { get; set; }

        [Display(Name = "File path")]
        public string FullPath { get; set; }

        [Display(Name = "Creation date time")]
        public DateTime? CreationDateTime { get; set; }
    }
}