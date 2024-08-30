using Core.Entities;

namespace Core.Specifications
{
    public class ProductSpecification : BaseSpecification<Product>
    {
        public ProductSpecification(ProductSpecParams SpecParams)
                : base(
                      x => (!SpecParams.Brand.Any() || SpecParams.Brand.Contains(x.Brand))
                        && (!SpecParams.Type.Any() || SpecParams.Type.Contains(x.Type))
                      )
        {
            switch (SpecParams.Sort)
            {
                case "priceAsc":
                    AddOrderBy(x => x.Price);
                    break;

                case "priceDesc":
                    AddOrderByDescending(x => x.Price);
                    break;

                default:
                    AddOrderBy(x => x.Name);
                    break;
            }
        }
    }
}