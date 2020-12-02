from django_pyscss import DjangoScssCompiler
from django_pyscss.compressor import DjangoScssFilter

class MyDjangoScssFilter(DjangoScssFilter):
    compiler = DjangoScssCompiler(
        # Example configuration
        output_style='compressed',
    )
