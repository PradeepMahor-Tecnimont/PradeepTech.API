namespace TCMPLApp.WebApi.Repositories
{
    public interface IPDFGenerator
    {
        public Task<byte[]> GeneratePDF(string HtmlContent);
    }
}
