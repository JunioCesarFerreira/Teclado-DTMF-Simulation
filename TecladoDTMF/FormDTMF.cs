using System;
using System.Drawing;
using System.Windows.Forms;
using System.Drawing.Drawing2D;
using System.Collections.Generic;

namespace MyDataReceiver
{
    public partial class FormDTMF : Form
    {
        #region Atributos
        // Constantes
        private const int N = 256;      // Comprimento dos vetores utilizados
        private const float FS = 4000;  // Frequência de amostragem

        // Variaveis para representação gráfico XY
        private float eixo_x = 0;
        private float eixo_y = 0;

        // Coeficientes de conversão para os gráficos
        private const float CoefX1 = FS / N;
        private const float CoefY1 = (float)(0.01);

        // Relacionados à interface
        private byte Cont_Tecla = 0;   // Contador para limpeza do label de visualização das teclas digitadas

        private AlgorithmType AlgSelected = AlgorithmType.FastFourierTransform;  // Indexador para seleção do algoritmo a ser utilizado

        // Lista de frequências do DTMF
        private readonly int[] Freq = { 697, 770, 852, 941, 1202, 1336, 1477 };

        // Lista de botões do teclado
        private readonly List<Button> TecladoDTMF = new List<Button>();
        #endregion

        // Método construtor do form
        public FormDTMF()
        {
            // Inicializa componentes do form
            InitializeComponent(); 
            // Carrega lista com botões que representam o teclado DTMF
            TecladoDTMF.Add(button1);
            TecladoDTMF.Add(button2);
            TecladoDTMF.Add(button3);
            TecladoDTMF.Add(button4);
            TecladoDTMF.Add(button5);
            TecladoDTMF.Add(button6);
            TecladoDTMF.Add(button7);
            TecladoDTMF.Add(button8);
            TecladoDTMF.Add(button9);
            TecladoDTMF.Add(buttonA);
            TecladoDTMF.Add(button0);
            TecladoDTMF.Add(buttonS);
        }
        
        // Método executado ao inicializar o form
        private void Form1_Load(object sender, EventArgs e)
        {
            #region Initialize Graph 1 Spectro
            xyGraph1.AddGraph("XtraTitle", DashStyle.Solid, Color.White, 1, false);
            xyGraph1.XtraLabelX = "Frequência (Hz)";
            xyGraph1.XtraLabelY = "";
            xyGraph1.XtraTitle = "Espectro de Frequências";
            xyGraph1.XtraAutoScale = false;
            // Configura gráfico que exibe espectro de frequências
            xyGraph1.XtraXmax = FS / 2;
            xyGraph1.XtraXmin = 0;
            xyGraph1.XtraYmax = 1;
            xyGraph1.XtraYmin = 0;
            xyGraph1.Validate(true);
            xyGraph1.XtraShowGrid = true;
            #endregion

            #region Initialize Graph 2 Signal
            xyGraph2.AddGraph("XtraTitle", DashStyle.Solid, Color.White, 1, false);
            xyGraph2.XtraLabelX = "Tempo (signal)";
            xyGraph2.XtraLabelY = "Amplitude";
            xyGraph2.XtraTitle = "Sinal";
            xyGraph2.XtraAutoScale = false;
            // Configura gráfico que exibe sinal no tempo
            xyGraph2.XtraXmin = 0;
            xyGraph2.XtraXmax = N / FS;
            xyGraph2.XtraYmax = 2;
            xyGraph2.XtraYmin = -2;
            xyGraph2.Validate(true);
            xyGraph2.XtraShowGrid = true;
            #endregion
        }   
             
        /// <summary>
        /// Método de detecção das teclas precionadas por análise espectral
        /// </summary>
        /// <param name="f">Vetor que representa espectro de frequências</param>
        /// <returns>Caracter filtrado o espaço caso resultado seja inconclusivo</returns>
        private char Detect_key(double[] f)
        {
            uint Ind1=0, Ind2=0;   // Indexadores das duas maiores componentes do espectro
            byte Comp1=0, Comp2=0; // Componentes detectadas

            #region Encontra indeces dos pontos máximos do espectro
            double Max = 0; // Máximo auxiliar na detecção
            for (uint j = 0; j < N/2; j++)
            {
                if (f[j] > Max)
                {
                    Max = f[j];
                    Ind1 = j;
                }
            }
            Max = 0;
            for (uint j = 0; j < N/2; j++)
            {
                if (j!=Ind1 && f[j] > Max)
                {
                    Max = f[j];
                    Ind2 = j;
                }
            }
            #endregion

            #region Ordena indices dos máximos
            if (Ind1 > Ind2)
            {
                uint tmp = Ind1;
                Ind1 = Ind2;
                Ind2 = tmp;
            }
            LB_M1.Text = "M1=" + (Ind1 * CoefX1).ToString() + "Hz";
            LB_M2.Text = "M2=" + (Ind2 * CoefX1).ToString() + "Hz";
            #endregion

            #region Realiza filtragem
            if (Ind1 < 1000 * N / FS)
            {
                Comp1++;
                if (Ind1 < 900 * N / FS)
                {
                    Comp1++;
                    if (Ind1 < 810 * N / FS)
                    {
                        Comp1++;
                        if (Ind1 < 720 * N / FS)
                        {
                            Comp1++;
                            if (Ind1 < 630 * N / FS) Comp1 = 0;
                        }
                    }
                }
            }
            if (Ind2 < 1520 * N / FS)
            {
                Comp2 += 10;
                if (Ind2 < 1400 * N / FS)
                {
                    Comp2 += 10;
                    if (Ind2 < 1300 * N / FS)
                    {
                        Comp2 += 10;
                        if (Ind2 < 1150 * N / FS) Comp2 = 0;
                    }
                }
            }
            #endregion

            #region Seleciona caractere prescionado
            switch (Comp1 + Comp2)
            {
                case 34:
                    return '1';
                case 24:
                    return '2';
                case 14:
                    return '3';
                case 33:
                    return '4';
                case 23:
                    return '5';
                case 13:
                    return '6';
                case 32:
                    return '7';
                case 22:
                    return '8';
                case 12:
                    return '9';
                case 31:
                    return '*';
                case 21:
                    return '0';
                case 11:
                    return '#';
            }
            return ' ';
            #endregion
        }

        // Click dos botões do teclado DTMF
        private void Click_TecladoDTMF(object sender, EventArgs e)
        {
            string Btn = "";                           // Texto para seleção de frequências segundo o botão prescionado
            double[] signalArray = new double[N];      // Vetor que representa o sinal
            double[] frequencyArray = new double[N];   // Vetor de espectro de frequências
            BeepClass Beep = new BeepClass(80, 10000); // Instancia classe que executa o som do beep
            Signal signal = new Signal(N, FS);         // Instancia classe de geração e manipulação dos sinais
            float f1 = 0, f2 = 0;                      // Frequencias do DTMF

            // Verifica qual botão foi prescionado
            foreach (Button B in TecladoDTMF)
            {
                if (B.GetHashCode() == sender.GetHashCode())
                {
                    Btn = B.Text;
                    break;
                }
            }

            // Seleciona frequências DTMF
            switch (Btn)
            {
                case "1":
                    f1 = 697;
                    f2 = 1209;
                    break;
                case "2":
                    f1 = 697;
                    f2 = 1336;
                    break;
                case "3":
                    f1 = 697;
                    f2 = 1477;
                    break;
                case "4":
                    f1 = 770;
                    f2 = 1209;
                    break;
                case "5":
                    f1 = 770;
                    f2 = 1336;
                    break;
                case "6":
                    f1 = 770;
                    f2 = 1477;
                    break;
                case "7":
                    f1 = 852;
                    f2 = 1209;
                    break;
                case "8":
                    f1 = 852;
                    f2 = 1336;
                    break;
                case "9":
                    f1 = 852;
                    f2 = 1477;
                    break;
                case "*":
                    f1 = 941;
                    f2 = 1209;
                    break;
                case "0":
                    f1 = 941;
                    f2 = 1336;
                    break;
                case "#":
                    f1 = 941;
                    f2 = 1477;
                    break;
            }

            Beep.BeepDTMF(Convert.ToUInt16(f1), Convert.ToUInt16(f2), !checkBox1.Checked);

            // Monta sinal 
            if (!checkBox1.Checked)
            {
                signalArray = signal.Sinus(f1, 1, 0);
                double[] signalArrayAux = signal.Sinus(f2, 1, 0);
                signalArray = signal.Sum_Signal(signalArray, signalArrayAux);
            }
            else
            {
                signalArray = signal.Square(f1, 1, 0);
                double[] signalArrayAux = signal.Square(f2, 1, 0);
                signalArray = signal.Sum_Signal_Lim(signalArray, signalArrayAux, 1);
            }

            // Limpa gráfico dominio do tempo
            xyGraph2.ClearGraphs();

            // Carrega valores para o gráfico
            for (int n = 0; n < N; n++)
            {
                eixo_y = Convert.ToSingle(signalArray[n]);
                eixo_x = n * (1 / FS);
                xyGraph2.AddValue(0, eixo_x, eixo_y);
                xyGraph2.DrawAll();
            }

            // Exibe texto abaixo do teclado
            Out_Teclas.Text += Btn;
            Cont_Tecla++;
            if (Cont_Tecla > 20)
            {
                Out_Teclas.Text = " ";
                LB_Out.Text = " ";
                Cont_Tecla = 0;
            }

            // Computa espectro de frequências
            switch (AlgSelected)
            {
                case AlgorithmType.FastFourierTransform: // Transformada rápida de Fourier
                    frequencyArray = Algorithm.FFT(signalArray);
                    break;
                case AlgorithmType.GoertzelAlgorithm: // Algoritmo de Goertzel
                    frequencyArray = signal.Clear_Signal(frequencyArray); // Limpa vetor de espectro
                    // Aplica o AG nas frequencias de interesse
                    foreach (int Fr in Freq)
                    {
                        int n = Convert.ToInt32(Fr * N / FS);
                        frequencyArray[n] = Algorithm.Goertzel_Algorithm(n, signalArray);
                    }
                    break;
            }

            // Insere valores no gráfico de espectro
            xyGraph1.ClearGraphs();
            for (int n = 0; n < (N / 2); n++)
            {
                eixo_y = Convert.ToSingle(frequencyArray[n]) * CoefY1;
                eixo_x = n * CoefX1;
                xyGraph1.AddValue(0, eixo_x, eixo_y);
                xyGraph1.DrawAll();
            }

            // Decodifica e escreve resultado abaixo em Decode
            LB_Out.Text += Detect_key(frequencyArray);
        }

        // Click do botão de limpeza
        private void Button_Clear_Click(object sender, EventArgs e)
        {
            Out_Teclas.Text = " ";
            LB_Out.Text = " ";
            LB_M1.Text = "M1=0000Hz";
            LB_M2.Text = "M2=0000Hz";
            xyGraph1.ClearGraphs();
            xyGraph1.DrawAll();
            xyGraph2.ClearGraphs();
            xyGraph2.DrawAll();
            Cont_Tecla = 0;
        }

        // Click do botão de troca de algoritmos
        private void Click_BT_AlgorithmChange(object sender, EventArgs e)
        {
            AlgSelected++;
            if ((int)AlgSelected > 1) AlgSelected = AlgorithmType.FastFourierTransform;
            switch (AlgSelected)
            {
                case AlgorithmType.FastFourierTransform:
                    LB_Algorithm.Text = "Algorithm = FFT-DIT-CT   ";
                    break;
                case AlgorithmType.GoertzelAlgorithm:
                    LB_Algorithm.Text = "Algorithm = Goertzel     ";
                    break;
            }
        }
    }
}