create or replace and compile java source named "TimeBasedUUID" as
import java.security.SecureRandom;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Random;
import java.util.UUID;


public class TimeBasedUUID {

    /**
     * Генерирует time-based UUID для текущего системного времени со случайной составляющей
     * @return UUID в uppercase и без дефисов
     */
    public static String generateExternalFormattedUUIDForNow() {
        return formatToExternalId(generate(System.currentTimeMillis()));
    }

    /**
     * Генерирует time-based UUID для указанных даты-времени со случайной составляющей
     * @param dateTime Дата-время
     * @param dateTimeFormat Формат даты-времени по соглашениям Java, см. описание SimpleDateFormat
     * @return UUID в uppercase и без дефисов
     * @throws ParseException
     */
    public static String generateExternalFormattedUUIDForDateTime(String dateTime, String dateTimeFormat) throws ParseException {
        return formatToExternalId(generate(
            new SimpleDateFormat(dateTimeFormat)
                .parse(dateTime)
                .getTime()));
    }


    /**
     * Извлекает дату-время с временной зоной из time-based UUID
     * @param uuid UUID в uppercase и без дефисов
     * @return Дата-время, извлеченные из uuid, в формате dd.MM.yyyy HH:mm:ssZ, например 24.06.2018 01:02:03+0300
     */
    public static String readDateTimeTzFromUUID(String uuid) {
        return readDateTimeFromUUID(uuid, "dd.MM.yyyy HH:mm:ssZ");
    }

    /**
     * Извлекает дату-время из time-based UUID в указанном формате
     * @param uuid UUID в uppercase и без дефисов
     * @param dateTimeFormat Формат даты-времени по соглашениям Java, см. описание SimpleDateFormat
     * @return  Дата-время, извлеченные из uuid, в указанном формате
     */
    public static String readDateTimeFromUUID(String uuid, String dateTimeFormat) {

        return new SimpleDateFormat(dateTimeFormat).format(
            readTimestampFromUUID(
                fromExternalIdFormatted(uuid)
            )
        );
    }


    private static String formatToExternalId(UUID uuid) {
        checkNotNull(uuid, "uuid is null!");

        return uuid.toString().replace("-", "").toUpperCase();
    }

    private static UUID fromExternalIdFormatted(String externalId) {
        checkNotNull(externalId, "externalId is null!");
        checkArgument(externalId.length() == 32, "externalId is incorrect!");

        return UUID.fromString(externalId.substring(0, 8) + '-' + externalId.substring(8, 12) + '-' + externalId.substring(12, 16) + '-' + externalId.substring(16, 20) + '-' + externalId.substring(20));
    }

    private static Long readTimestampFromUUID(UUID uuid) {

        GregorianCalendar calendar = new GregorianCalendar();
        Date gregorianChange = calendar.getGregorianChange();
        calendar.setTime(gregorianChange);

        return calendar.getTimeInMillis() + (uuid.timestamp() / 10000);
    }

    private static UUID generate(long dateTimeEpochMillis) {
        byte[] uuidBytes = new byte[16];
        constructMulticastAddress().toByteArray(uuidBytes, 10);


        //TODO разобраться почему рандом
        int clockSeq = new Random().nextInt();

//        int clockSeq = getClockSequence;
        uuidBytes[8] = (byte) (clockSeq >> 8);
        uuidBytes[9] = (byte) clockSeq;
        long l2 = gatherLong(uuidBytes, 8);
        long _uuidL2 = initUUIDSecondLong(l2);


        long rawTimestamp = getTimestamp(dateTimeEpochMillis, clockSeq);
        int clockHi = (int) (rawTimestamp >>> 32);
        int clockLo = (int) rawTimestamp;
        int midhi = clockHi << 16 | clockHi >>> 16;
        midhi &= -61441;
        midhi |= 4096;
        long midhiL = (long) midhi;
        midhiL = midhiL << 32 >>> 32;
        long l1 = (long) clockLo << 32 | midhiL;
        return new UUID(l1, _uuidL2);
    }

    private static long gatherLong(byte[] buffer, int offset) {
        long hi = (long) _gatherInt(buffer, offset) << 32;
        long lo = (long) _gatherInt(buffer, offset + 4) << 32 >>> 32;
        return hi | lo;
    }

    private static int _gatherInt(byte[] buffer, int offset) {
        return buffer[offset] << 24 | (buffer[offset + 1] & 255) << 16 | (buffer[offset + 2] & 255) << 8 | buffer[offset + 3] & 255;
    }

    private static long initUUIDSecondLong(long l2) {
        l2 = l2 << 2 >>> 2;
        l2 |= -9223372036854775808L;
        return l2;
    }


    private static synchronized long getTimestamp(int _clockSequence) {
        return getTimestamp(System.currentTimeMillis(), _clockSequence);
    }

    private static long getTimestamp(long dateTimeMillis, int _clockSequence) {
        int _clockCounter = _clockSequence >> 16 & 255;


        dateTimeMillis *= 10000L;
        dateTimeMillis += 122192928000000000L;
        dateTimeMillis += (long) _clockCounter;
        ++_clockCounter;
        return dateTimeMillis;
    }

    private static EthernetAddress constructMulticastAddress() {
        return constructMulticastAddress(_randomNumberGenerator());
    }

    private static class EthernetAddress {

        protected final long _address;

        public EthernetAddress(byte[] addr) throws NumberFormatException {
            if (addr.length != 6) {
                throw new NumberFormatException("Ethernet address has to consist of 6 bytes");
            } else {
                long l = (long) (addr[0] & 255);

                for (int i = 1; i < 6; ++i) {
                    l = l << 8 | (long) (addr[i] & 255);
                }

                this._address = l;
            }
        }

        public void toByteArray(byte[] array, int pos) {
            if (pos >= 0 && pos + 6 <= array.length) {
                int i = (int) (this._address >> 32);
                array[pos++] = (byte) (i >> 8);
                array[pos++] = (byte) i;
                i = (int) this._address;
                array[pos++] = (byte) (i >> 24);
                array[pos++] = (byte) (i >> 16);
                array[pos++] = (byte) (i >> 8);
                array[pos] = (byte) i;
            } else {
                throw new IllegalArgumentException("Illegal offset (" + pos + "), need room for 6 bytes");
            }
        }
    }

    private static EthernetAddress constructMulticastAddress(Random rnd) {
        byte[] dummy = new byte[6];
        synchronized (rnd) {
            rnd.nextBytes(dummy);
        }

        dummy[0] = (byte) (dummy[0] | 1);
        return new EthernetAddress(dummy);
    }

    private static Random _rnd;

    private static synchronized Random _randomNumberGenerator() {
        if (_rnd == null) {
            _rnd = new SecureRandom();
        }

        return _rnd;
    }

    private static <T> T checkNotNull(T reference, String errorMessage) {
        if (reference == null) {
            throw new NullPointerException(errorMessage);
        } else {
            return reference;
        }
    }

    private static void checkArgument(boolean expression, String errorMessage) {
        if (!expression) {
            throw new IllegalArgumentException(errorMessage);
        }
    }
}
/
