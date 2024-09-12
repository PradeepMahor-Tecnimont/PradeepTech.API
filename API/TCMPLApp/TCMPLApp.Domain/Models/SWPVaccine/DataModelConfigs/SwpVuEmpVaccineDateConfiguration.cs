using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpVuEmpVaccineDateConfiguration : IEntityTypeConfiguration<SwpVuEmpVaccineDate>
    {
        public void Configure(EntityTypeBuilder<SwpVuEmpVaccineDate> entity)
        {
            
            entity.ToView("SWP_VU_EMP_VACCINE_DATE");

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.FirstJabSponsor).IsUnicode(false);

            entity.Property(e => e.Grade).IsUnicode(false);

            entity.Property(e => e.Name).IsUnicode(false);

            entity.Property(e => e.Parent)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.SecondJabSponsor).IsUnicode(false);

            entity.Property(e => e.VaccineType).IsUnicode(false);

        }
    }
}