namespace TCMPLApp.WebApp.Models
{
    public class EmailViewModel : Domain.Models.Logs.EmailDataTableList
    {
        public EmailViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}