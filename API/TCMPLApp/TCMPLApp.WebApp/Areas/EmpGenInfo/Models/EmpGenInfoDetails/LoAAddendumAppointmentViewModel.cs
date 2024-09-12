namespace TCMPLApp.WebApp.Models
{
    public class LoAAddendumAppointmentViewModel : Domain.Models.EmpGenInfo.LoAAddendumAppointmentDataTableList
    {
        public LoAAddendumAppointmentViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
