namespace Core.Specifications
{
    public class ProductSpecParams
    {
        private List<string> _brand = [];

        public List<string> Brand
        {
            get { return _brand; }
            set
            {
                _brand = value.SelectMany
                            (x => x.Split(',', StringSplitOptions.RemoveEmptyEntries))
                                .ToList();
            }
        }

        private List<string> _type = [];

        public List<string> Type
        {
            get { return _type; }
            set
            {
                _type = value.SelectMany
                            (x => x.Split(',', StringSplitOptions.RemoveEmptyEntries))
                                .ToList();
            }
        }

        public string? Sort { get; set; }
    }
}