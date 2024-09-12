using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLAPP.WinService.Models
{
    public class WSMessageExtensionModel<T> : WSMessageModel where T : class
    {
        public T Data { get; set; }
    }
}
