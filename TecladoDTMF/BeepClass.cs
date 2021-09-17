using System;
using System.IO;

namespace MyDataReceiver
{
    internal class BeepClass
    {
        private readonly int msDuration;
        private readonly uint volume;

        public BeepClass(int Durat, uint vol)
        {
            msDuration = Durat;
            volume = vol;
        }

        /// <summary>
        /// Função para gerar sinal sonoro
        /// </summary>
        /// <param name="frequency1">Frequência 1</param>
        /// <param name="frequency2">Frequêncica 2</param>
        /// <param name="sign">Tipo do sinal, true para senoidal, false para quadrado</param>
        public void BeepDTMF (uint frequency1, uint frequency2, bool sign)
        {
            const double TAU = 2 * Math.PI;
            int formatChunkSize = 16;
            int headerSize = 8;
            short formatType = 1;
            short tracks = 1;
            int samplesPerSecond = 44100;
            short bitsPerSample = 16;
            short frameSize = (short)(tracks * ((bitsPerSample + 7) / 8));
            int bytesPerSecond = samplesPerSecond * frameSize;
            int waveSize = 4;
            int samples = (int)((decimal)samplesPerSecond * msDuration / 1000);
            int dataChunkSize = samples * frameSize;
            int fileSize = waveSize + headerSize + formatChunkSize + headerSize + dataChunkSize;
            var mStrm = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(mStrm);
            // var encoding = new System.Text.UTF8Encoding();
            writer.Write(0x46464952); // = encoding.GetBytes("RIFF")
            writer.Write(fileSize);
            writer.Write(0x45564157); // = encoding.GetBytes("WAVE")
            writer.Write(0x20746D66); // = encoding.GetBytes("fmt ")
            writer.Write(formatChunkSize);
            writer.Write(formatType);
            writer.Write(tracks);
            writer.Write(samplesPerSecond);
            writer.Write(bytesPerSecond);
            writer.Write(frameSize);
            writer.Write(bitsPerSample);
            writer.Write(0x61746164); // = encoding.GetBytes("data")
            writer.Write(dataChunkSize);
            {
                double theta1 = frequency1 * TAU / samplesPerSecond;
                double theta2 = frequency2 * TAU / samplesPerSecond;
                // 'volume' is UInt16 with range 0 thru Uint16.MaxValue ( = 65 535)
                // we need 'amp' to have the range of 0 thru Int16.MaxValue ( = 32 767)
                double amp = volume >> 2; // so we simply set amp = volume / 2
                for (int step = 0; step < samples; step++)
                {
                    short s;
                    if (sign) s = (short)(amp * (Math.Sin(theta1 * step) + Math.Sin(theta2 * step)));
                    else s = (short)(amp * Math.Sign(Math.Sin(theta1 * step) + Math.Sin(theta2 * step)));
                    writer.Write(s);
                }
            }

            mStrm.Seek(0, SeekOrigin.Begin);
            new System.Media.SoundPlayer(mStrm).Play();
            writer.Close();
            mStrm.Close();
        }
    }
}
