using System;

namespace MyDataReceiver
{
    internal class Signal
    {
        private readonly int N;
        private readonly float SamplingFrequency;

        /// <summary>
        /// Método construtor
        /// </summary>
        /// <param name="Lenght">Comprimento para vetor de sinal</param>
        /// <param name="Sample">Frequência de amostragem</param>
        public Signal(int Lenght, float Sample)
        {
            N = Lenght;
            SamplingFrequency = Sample;
        }

        /// <summary>
        /// Método retorna vetor com representação de uma senoide
        /// </summary>
        /// <param name="F">Frequência em Hertz</param>
        /// <param name="A">Amplitude unidade qualquer</param>
        /// <param name="phi">Fase em radianos</param>
        /// <returns>Vetor representativo</returns>
        public double[] Sinus(double F, double A, double phi)
        {
            double[] s = new double[N];
            F = 2 * Math.PI * F / SamplingFrequency;
            for (int k = 0; k < N; k++) s[k] = A * Math.Sin(F * k + phi);
            return s;
        }

        /// <summary>
        /// Método retorna vetor com representação de uma onda quadrada
        /// </summary>
        /// <param name="F">Frequência em Hertz</param>
        /// <param name="A">Amplitude unidade qualquer</param>
        /// <param name="phi">Fase em radianos</param>
        /// <returns>Vetor representativo</returns>
        public double[] Square(double F, double A, double phi)
        {
            double[] s = new double[N];
            F = 2 * Math.PI * F / SamplingFrequency;
            for (int k = 0; k < N; k++)
            {
                double aux = A * Math.Sin(F * k + phi);
                if (aux > 0) s[k] = 1;
                else s[k] = 0;
            }
            return s;
        }

        /// <summary>
        /// Método soma sinais
        /// </summary>
        /// <param name="signal1">Sinal 1</param>
        /// <param name="signal2">Sinal 2</param>
        /// <returns>Vetor resultante da soma</returns>
        public double[] Sum_Signal(double[] signal1, double[] signal2)
        {
            double[] sum;
            int M;

            if (signal1.Length > signal2.Length)
            {
                M = signal2.Length;
                sum = signal1;
            }
            else if (signal1.Length < signal2.Length)
            {
                M = signal1.Length;
                sum = signal2;
            }
            else
            {
                M = signal1.Length;
                sum = signal1;
            }

            for (int n = 0; n < M; n++) sum[n] = signal1[n] + signal2[n];

            return sum;
        }

        /// <summary>
        /// Método soma sinais com resultado limitado
        /// </summary>
        /// <param name="signal1">Sinal 1</param>
        /// <param name="signal2">Sinal 2</param>
        /// <param name="L">Limite</param>
        /// <returns>Vetor resultante da soma</returns>
        public double[] Sum_Signal_Lim(double[] signal1, double[] signal2, double L)
        {
            double[] sum;
            int M;

            if (signal1.Length > signal2.Length)
            {
                M = signal2.Length;
                sum = signal1;
            }
            else if (signal1.Length < signal2.Length)
            {
                M = signal1.Length;
                sum = signal2;
            }
            else
            {
                M = signal1.Length;
                sum = signal1;
            }

            for (int n = 0; n < M; n++)
            {
                sum[n] = signal1[n] + signal2[n];
                if (sum[n] > L) sum[n] = L;
            }

            return sum;
        }

        /// <summary>
        /// Zera o vetor
        /// </summary>
        public double[] Clear_Signal(double[] signal)
        {
            for (int n = 0; n < N; n++) signal[n] = 0;
            return signal;
        }
    }
}