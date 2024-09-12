using System.Collections.Generic;

namespace TCMPLApp.Library.Excel.Template.Models
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
