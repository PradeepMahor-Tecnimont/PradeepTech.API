﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.WinService.Models;

namespace TCMPLAPP.WinService.Areas
{
    public interface ISWP
    {
        public WSMessageModel ExecuteProcess(ProcessQueueModel processQueueModel);
    }

}
