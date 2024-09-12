using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetMapWithEmpDataTableExcel
    {
        public string Empno { get; set; }

        public string Name { get; set; }

        public string GroupType { get; set; }

        public string ItemId { get; set; }

        public string TypeDesc { get; set; }

        public string AssetType { get; set; }

        public string Description { get; set; }
    }
}
