using System.Collections.Generic;

namespace TCMPLApp.WebApp.Areas.ExcelTemplate.Models
{
    public class DictionaryCollection
    {
        public DictionaryCollection()
        {

            this.DictionaryItems = new List<DictionaryItem>();
        }

        public List<DictionaryItem> DictionaryItems { get; set; }
    }
}
