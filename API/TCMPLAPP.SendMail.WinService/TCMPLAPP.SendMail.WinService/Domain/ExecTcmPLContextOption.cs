namespace TCMPLAPP.SendMail.WinService.Context
{
    public class ExecTcmPLContextOption
    {

        public ExecTcmPLContextOption(bool disableCache)
        {

            this.DisableCache = disableCache;

        }

        public bool DisableCache { get; set; }

    }
}
