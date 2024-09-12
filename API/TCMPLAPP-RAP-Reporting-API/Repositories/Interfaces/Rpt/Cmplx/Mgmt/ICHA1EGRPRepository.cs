using System;

namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.Mgmt
{
    public interface ICHA1EGRPRepository
    {
        object GetCostcodeList(string costgrp);

        object GetCha1ECostcodeData(string yymm, string costcode, string simul, string activeYear, string reportMode);

        object GetCha1EGrpData(string yymm, string category, string simul, Int32 mnths, string activeYear);
    }
}