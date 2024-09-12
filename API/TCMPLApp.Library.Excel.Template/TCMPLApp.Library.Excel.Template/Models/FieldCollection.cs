using System.Collections.Generic;

namespace TCMPLApp.Library.Excel.Template.Models
{
    public class FieldCollection
    {

        public FieldCollection()
        {

            this.FieldItems = new List<FieldItem>();
        }

        public List<FieldItem> FieldItems { get; set; }

    }
}
