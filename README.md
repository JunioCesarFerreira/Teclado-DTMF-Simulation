# Teclado_DTMF_Simula-o
Programa em C# simula decodificador de teclado DTMF por Algoritmo de Goertzel e FFT radix-2 Cooley-Tukey, este arquivo é para fins didáticos, junto, segue um pequeno [tutorial em pdf](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/Decodificador%20digital%20de%20tons%20DTMF(1).pdf).<br />

Neste repositório encontra-se o projeto completo desenvolvido no VS2012, versão 0 [TecladoDTMF_v0](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/TecladoDTMF_v0.zip), também encontra-se uma versão 1 [TecladoDTMF_v1](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/TecladoDTMF_v1.zip), na versão 1 foram adicionados efeitos sonoros ao teclar os botões do teclado DTMF, e uma CheckBox no canto superior esquerdo, que quando marcada altera o sinal de saída quadrado, para simular por exemplo que este foi gerado de maneira simples em um microcontrolador.<br />
Todos os projetos estão completos e zipados no repositório, mas disponibilizei para apreciação os códigos:<br />
Utilizado para gerar o sinal DTMF no PIC18F2550 [TecladoDTMF](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/TecladoDTMF.c)<br />
Utilizado para decodificar DTMF com PIC18F2550 [DecodeDTMF](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/DTMF_Decode.c)<br />
Classe em C# da versão 3 com os algoritmos [Algorithm](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/Algorithm.cs)<br />
Form em C# da versão 3 [Form V3](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/FormDTMF.cs)<br />
Classe em C# de geração dos sinais [Signal](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/Signal.cs)<br />
Código da versão anterior em C# [Form1](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/Form1.cs), sendo este código da versão 0.<br />

Abaixo apresenta-se um print da interface v0.
<br />
<br />
![Alt Text](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/Img.png)
<br />

Abaixo apresenta-se um print da interface v1, a versão 3 continua com essa mesma tela.
<br />
<br />
![Alt Text](https://github.com/JunioCesarFerreira/Teclado_DTMF_Simula-o/blob/master/Img2.png)
<br />
<br />
Qualquer dúvida ou sugestão entre em contato jcf_ssp@hotmail.com
