﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Context
{
    public interface IViewTcmPLRepository<T> : IDisposable
    {
        Task<T> GetAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        //Task<T> GetCacheAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL, string[] tags);

        Task<IEnumerable<T>> GetAllAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL, bool isStoreProc = true);

        //Task<IEnumerable<T>> GetAllCacheAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL, string[] tags);

        Task<DataTable> GetDataTableAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL, bool isStoreProc = true);
    }
}
