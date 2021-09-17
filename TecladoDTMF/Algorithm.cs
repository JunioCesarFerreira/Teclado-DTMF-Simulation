using System;

namespace MyDataReceiver
{
    internal enum AlgorithmType
    {
        FastFourierTransform,
        GoertzelAlgorithm
    }

    internal static class Algorithm
    {
        /// <summary>
        /// Função reversora de bits
        /// </summary>
        /// <param name="index"></param>
        /// <param name="Lenght"></param>
        /// <returns></returns>
        private static int Table_Reverse(uint index, int Lenght)
        {
            // Essa função faz a reversão (ou espelhamento) de bits necessária ao fim do computo da FFT
            // Obs.: o switch abaixo retorna o logaritmo na base 2 da entrada Lenght
            int _Lim = 0;
            uint mirror;
            switch (Lenght)
            {
                case 8:
                    _Lim = 3;
                    break;
                case 16:
                    _Lim = 4;
                    break;
                case 32:
                    _Lim = 5;
                    break;
                case 64:
                    _Lim = 6;
                    break;
                case 128:
                    _Lim = 7;
                    break;
                case 256:
                    _Lim = 8;
                    break;
                case 512:
                    _Lim = 9;
                    break;
                case 1024:
                    _Lim = 10;
                    break;
            }
            // Computa o espelhamento propriamente dito
            mirror = 0;
            for (uint exp = 0; exp < _Lim; exp++)
            {
                mirror = mirror << 1;
                mirror += (0x01 & index);
                index = index >> 1;
            }
            return (int)mirror;
        }
       
        /// <summary>
        /// Computa FFT Algoritmo radix-2 Cooley-Tukey decimation in time
        /// </summary>
        /// <param name="array">Vetor para computo</param>
        /// <returns>Vetor resultado</returns>
        public static double[] FFT(double[] array)
        {
            int N = array.Length;
            if (N < 1)
            {
                throw new Exception("Vetor inválido na entrada de FFT");
            }
            double[] Xreal = new double[N];  // Vetor entrada parte real
            double[] Ximag = new double[N];  // Vetor entrada parte imaginária
            double[] Wr = new double[N];     // Vetor de coeficientes de Fourier parte real 
            double[] Wi = new double[N];     // Vetor de coeficientes de Fourier parte imag.
            double pi_N = 2 * Math.PI / N;   // Auxiliar Pi*n
            // Carrega vetores
            for (int i = 0; i < N; i++)
            {
                Xreal[i] = array[i];
                Ximag[i] = 0;
            }
            // Carrega vetor de coeficientes
            for (int i = 0; i < N; i++)
            {
                Wr[i] = Math.Cos(pi_N * i);
                Wi[i] = -Math.Sin(pi_N * i);
            }

            // Computa FFT Cooley-Tukey radix-2
            for (int P = 2; P <= N; P = 2 * P)
            {
                // Deslocamento da Butterfly principal
                for (int k = 0; k < N / P; k++)
                {
                    int L = (P / 2) - 1; // Limite para deslocamentos da Butterfly do nível atual
                    int NP = N / P;      // Comprimento da DFT decomposta
                    int desl = 2 * NP;   // Fator de deslocamento interno do nível
                    for (int i = 0; i <= L; i++)
                    {
                        // Prepara entradas da Butterfly
                        double ar = Xreal[k + i * desl];
                        double ai = Ximag[k + i * desl];
                        double br = Xreal[k + NP + i * desl];
                        double bi = Ximag[k + NP + i * desl];
                        // Computa Butterfly DIF ...
                        Xreal[k + i * desl] = ar + br;
                        Ximag[k + i * desl] = ai + bi;
                        br = ar - br;
                        bi = ai - bi;
                        Xreal[k + NP + i * desl] = br * Wr[k * P / 2] - bi * Wi[k * P / 2];
                        Ximag[k + NP + i * desl] = br * Wi[k * P / 2] + bi * Wr[k * P / 2];
                    }
                }
            }
            // Reverte resultado e calcula magnitude
            for (int i = 0; i < N; i++)
            {
                array[Table_Reverse((uint)i, N)] = Math.Sqrt(Xreal[i] * Xreal[i] + Ximag[i] * Ximag[i]);
            }
            return array;
        }

        /// <summary>
        /// Algoritmo de Goertzel (AG) para uma frequência
        /// </summary>
        /// <param name="index">Indexador do vetor de recebimento relativo a frequência</param>
        /// <param name="v">Vetor de sinal para cômputo</param>
        /// <returns>Valor do espectro em Fr</returns>
        public static double Goertzel_Algorithm(int index, double[] v)
        {
            int N = v.Length;
            double w = 2 * Math.PI * index / N;
            double cosw = Math.Cos(w);
            double sinw = Math.Sin(w);
            double coefk = 2 * cosw;
            // Auxiliares para contas
            double r0, r1 = 0, r2 = 0;
            // Computa Algoritmo de Goertzel
            for (int n = 0; n < N; n++)
            {
                r0 = coefk * r1 - r2 + v[N - n - 1];
                r2 = r1;
                r1 = r0;
            }
            r0 = (r1 - r2 * cosw);             // Componente Real
            r1 = (r2 * sinw);                  // Componente imaginária  
            r2 = Math.Sqrt(r0 * r0 + r1 * r1); // Magnitude               
            return r2;
        }
    }
}