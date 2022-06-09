import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/helpers/functions.dart';
import 'package:in_market_delivery_app/helpers/sign_history.dart';
import 'package:in_market_delivery_app/models/delivery.dart';
import 'package:in_market_delivery_app/models/shop_order.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/providers/order.dart';
import 'package:in_market_delivery_app/widgets/cart_list.dart';
import 'package:in_market_delivery_app/widgets/error_dialog.dart';
import 'package:in_market_delivery_app/widgets/label_column.dart';
import 'package:in_market_delivery_app/widgets/round_button.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final ShopOrderModel order;

  const DetailScreen({required this.order, Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final SignController _controller = SignController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    DeliveryModel? delivery = authProvider.delivery;
    final orderProvider = Provider.of<OrderProvider>(context);
    String title = '';
    if (widget.order.status == 2) {
      title = '配達待ち';
    } else if (widget.order.status == 3) {
      title = '配達中';
    }

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('$title - 詳細'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 3,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    widget.order.status == 3
                        ? LabelColumn(
                            labelText: 'デジタル署名',
                            children: [
                              Signer(paintController: _controller),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    widget.order.status == 2
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: RoundButton(
                              labelText: '配達中にする',
                              labelColor: Colors.white,
                              backgroundColor: Colors.blue.shade400,
                              onPressed: () async {
                                String? errorText = await orderProvider.update(
                                  order: widget.order,
                                  delivery: delivery,
                                  status: 3,
                                );
                                if (errorText != null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ErrorDialog(
                                      message: errorText,
                                    ),
                                  );
                                  return;
                                }
                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          )
                        : Container(),
                    widget.order.status == 3
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: RoundButton(
                              labelText: '配達完了にする',
                              labelColor: Colors.white,
                              backgroundColor: Colors.blue.shade400,
                              onPressed: () async {
                                String? errorText = await orderProvider.update(
                                  order: widget.order,
                                  delivery: delivery,
                                  status: 0,
                                );
                                if (errorText != null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ErrorDialog(
                                      message: errorText,
                                    ),
                                  );
                                  return;
                                }
                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 32),
                    LabelColumn(
                      labelText: '注文情報',
                      children: [
                        Text(
                          '注文日時: ${dateText('yyyy/MM/dd HH:mm', widget.order.createdAt)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '注文者: ${widget.order.userName}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LabelColumn(
                      labelText: '注文商品',
                      children: widget.order.cartList.map((cart) {
                        return CartList(cart: cart);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Signer extends StatefulWidget {
  final SignController paintController;

  Signer({required this.paintController})
      : super(key: ValueKey<SignController>(paintController));

  @override
  _SignerState createState() => _SignerState();
}

class _SignerState extends State<Signer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      height: 200,
      child: GestureDetector(
        onPanStart: _onPaintStart,
        onPanUpdate: _onPaintUpdate,
        onPanEnd: _onPaintEnd,
        child: CustomPaint(
          willChange: true,
          painter: _CustomPainter(
            widget.paintController._paintHistory,
            repaint: widget.paintController,
          ),
        ),
      ),
    );
  }

  void _onPaintStart(DragStartDetails start) {
    widget.paintController._paintHistory
        .addPaint(_getGlobalToLocalPosition(start.globalPosition));
    widget.paintController._notifyListeners();
  }

  void _onPaintUpdate(DragUpdateDetails update) {
    widget.paintController._paintHistory
        .updatePaint(_getGlobalToLocalPosition(update.globalPosition));
    widget.paintController._notifyListeners();
  }

  void _onPaintEnd(DragEndDetails end) {
    widget.paintController._paintHistory.endPaint();
    widget.paintController._notifyListeners();
  }

  Offset _getGlobalToLocalPosition(Offset global) {
    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }
}

class _CustomPainter extends CustomPainter {
  final SignHistory _paintHistory;

  _CustomPainter(this._paintHistory, {required Listenable repaint})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _paintHistory.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) => true;
}

class SignController extends ChangeNotifier {
  final SignHistory _paintHistory = SignHistory();

  final Color _drawColor = Colors.black;

  final double _thickness = 2.0;

  final Color _backgroundColor = Colors.white;

  SignController() : super() {
    Paint paint = Paint();
    paint.color = _drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = _thickness;
    _paintHistory.currentPaint = paint;
    _paintHistory.backgroundColor = _backgroundColor;
  }

  void _notifyListeners() {
    notifyListeners();
  }

  void clear() {
    _paintHistory.clear();
    notifyListeners();
  }
}
