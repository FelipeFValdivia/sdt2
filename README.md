El presente README describe los elementos utilizados para desarrollar la tarea 2 de sistemas distribuidos.

El servicio de aviones está desarrollado con ruby.

El servicio de torre de control está desarrollado con ṕython.

El servicio de pantallas de control está desarrollado con node.

Los servicios fueron ejecutados con las siguientes versiones de cada lenguaje:
ruby 2.4
python 2.7
node 7.8.0

Se recomienda utilizar las mismas versiones para evitar problemas de compatibilidad.


Nota: Para node es necesario instalar el package grpc, para esto se recomienda hacerlo mediante npm, instalando npm y luego ejecutando el comando:
npm install grpc --save