namespace TCMPLAPP.SendMail.WinService.Context
{
    public class ViewTcmPLContextOption
    {

        public ViewTcmPLContextOption(bool disableCache)
        {

            this.DisableCache = disableCache;

        }

        public bool DisableCache { get; set; }

    }
}
