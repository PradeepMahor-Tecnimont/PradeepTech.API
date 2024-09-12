using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaCategoriesDetails : DBProcMessageOutput
    {
        public string PAreaDescription { get; set; }
    }
}