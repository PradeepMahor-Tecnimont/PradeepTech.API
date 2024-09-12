namespace TCMPLApp.Domain.Context
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
