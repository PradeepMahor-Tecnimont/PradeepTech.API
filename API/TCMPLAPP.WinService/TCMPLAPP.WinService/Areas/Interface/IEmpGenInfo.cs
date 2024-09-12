using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;

namespace TCMPLAPP.WinService.Areas
{
    public interface IEmpGenInfo
    {
        public WSMessageModel ExecuteProcess(ProcessQueueModel processQueueModel);
    }
}