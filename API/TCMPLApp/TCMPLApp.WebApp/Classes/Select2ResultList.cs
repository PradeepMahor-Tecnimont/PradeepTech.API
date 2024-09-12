

using System.Collections.Generic;

namespace TCMPLApp.WebApp.Classes
{
    public class Select2ResultList<T>
    {
        public List<T> items { get; set; }
        public decimal totalCount { get; set; }
    }
}